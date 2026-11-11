#!/usr/bin/env bash

set -Eeuo pipefail

QML="$HOME/.config/quickshell/Captura/shell.qml"
DIR="$HOME/Imágenes/Capturas"
VDIR="$(xdg-user-dir VIDEOS 2>/dev/null || true)"
[[ -n $VDIR && $VDIR != "$HOME" ]] || VDIR="$HOME/Vídeos"
VDIR="$VDIR/Capturas"

MODE=""
COPY=0
CURSOR=0
VIDEO=0
GEOM=""
OUTPUT=""

usage() {
    cat <<'USAGE'
captura.sh — capturas y grabaciones para Hyprland (grim + wf-recorder + Quickshell)

Uso:
  captura.sh menu                    abre/cierra la herramienta; si se está grabando, detiene la grabación

Uso interno (lo llama la barra):
  captura.sh region --geometry "X,Y WxH" [--copy] [--cursor] [--video]
  captura.sh output --output NOMBRE      [--copy] [--cursor] [--video]

Fotos: PNG en ~/Imágenes/Capturas (--copy lo copia al portapapeles, --cursor incluye el puntero).
Video: MP4 en ~/Vídeos/Capturas, se detiene volviendo a ejecutar "captura.sh menu".

Dependencias: grim, quickshell, hyprctl (lo usa la barra)
              wf-recorder (--video) · wl-clipboard (--copy) · libnotify (avisos, opcional)
USAGE
}

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a Captura "$@" || true
    fi
}

die() {
    printf 'captura: %s\n' "$*" >&2
    notify "Captura: error" "$*"
    exit 1
}

need() {
    command -v "$1" >/dev/null 2>&1 || die "Falta '$1'. Instálalo con: sudo dnf install $2"
}

# ------------------------------------------------------------------------------
# Argumentos
# ------------------------------------------------------------------------------
while (( $# > 0 )); do
    case "$1" in
        menu|region|output) MODE="$1" ;;
        --copy) COPY=1 ;;
        --cursor) CURSOR=1 ;;
        --video) VIDEO=1 ;;
        --geometry)
            shift
            [[ ${1:-} =~ ^-?[0-9]+,-?[0-9]+\ [0-9]+x[0-9]+$ ]] \
                || die "--geometry necesita el formato \"X,Y WxH\"."
            GEOM="$1"
            ;;
        --output)
            shift
            [[ -n ${1:-} ]] || die "--output necesita el nombre del monitor."
            OUTPUT="$1"
            ;;
        -h|--help|help) usage; exit 0 ;;
        *) die "Argumento desconocido: $1 (usa --help)" ;;
    esac
    shift
done

if [[ -z $MODE ]]; then usage; exit 1; fi
if [[ $MODE == region && -z $GEOM ]]; then die "El modo 'region' necesita --geometry \"X,Y WxH\"."; fi
if [[ $MODE == output && -z $OUTPUT ]]; then die "El modo 'output' necesita --output NOMBRE."; fi

# ------------------------------------------------------------------------------
# Herramienta de Quickshell (el mismo atajo la abre y la cierra)
# ------------------------------------------------------------------------------
if [[ $MODE == menu ]]; then
    # Grabando: el atajo detiene la grabación (wf-recorder cierra el MP4 con SIGINT)
    if pgrep -x wf-recorder >/dev/null; then
        pkill -INT -x wf-recorder || true
        exit 0
    fi

    need quickshell quickshell
    if pgrep -f "quickshell.*Captura/shell.qml" >/dev/null; then
        pkill -f "quickshell.*Captura/shell.qml" || true
        exit 0
    fi
    exec quickshell -p "$QML"
fi

# ------------------------------------------------------------------------------
# Video
# ------------------------------------------------------------------------------
if (( VIDEO )); then
    need wf-recorder wf-recorder
    pgrep -x wf-recorder >/dev/null && die "Ya hay una grabación en curso."

    mkdir -p -- "$VDIR"
    vdest="$VDIR/grabacion_$(date +%Y-%m-%d_%H-%M-%S).mp4"
    vsummary="${vdest/#$HOME/\~}"

    case "$MODE" in
        region) rec=(wf-recorder -g "$GEOM" -f "$vdest") ;;
        output) rec=(wf-recorder -o "$OUTPUT" -f "$vdest") ;;
    esac

    notify -t 4000 "Grabando…" "Vuelve a pulsar el atajo para detener"

    # wf-recorder termina con código 0 cuando se detiene con SIGINT
    if "${rec[@]}"; then
        notify "Grabación guardada" "$vsummary"
        printf 'Grabación %s\n' "$vsummary"
    else
        rm -f -- "$vdest"
        die "wf-recorder falló; no se guardó la grabación."
    fi
    exit 0
fi

# ------------------------------------------------------------------------------
# Foto
# ------------------------------------------------------------------------------
need grim grim
if (( COPY )); then need wl-copy wl-clipboard; fi

mkdir -p -- "$DIR"
dest="$DIR/captura_$(date +%Y-%m-%d_%H-%M-%S).png"

# Si algo falla a medias, no deja un archivo roto.
trap 'rm -f -- "$dest"' ERR

grim_args=()
(( CURSOR )) && grim_args+=(-c)

case "$MODE" in
    region) grim "${grim_args[@]}" -g "$GEOM" "$dest" ;;
    output) grim "${grim_args[@]}" -o "$OUTPUT" "$dest" ;;
esac

summary="guardada en ${dest/#$HOME/\~}"

if (( COPY )); then
    wl-copy --type image/png < "$dest"
    summary+=" · copiada al portapapeles"
fi

trap - ERR

notify -i "$dest" "Captura tomada" "Captura $summary"
printf 'Captura %s\n' "$summary"
