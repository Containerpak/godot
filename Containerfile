FROM ubuntu:26.04 AS source

ADD --checksum=sha256:c7ff14fd28472c8d4f193043de30278dcf7e5241a1dcf7566b02e27addaa33ba https://github.com/godotengine/godot/releases/download/4.7.1-stable/Godot_v4.7.1-stable_linux.x86_64.zip /tmp/app.zip

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    mkdir -p /out && \
    unzip -q /tmp/app.zip -d /out && \
    mv /out/Godot_v4.7.1-stable_linux.x86_64 /out/godot

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/godot"

COPY --from=source /out/godot /opt/godot/godot

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libasound2t64 libfontconfig1 libgl1 libx11-6 libxcursor1 libxi6 libxinerama1 libxrandr2 libxrender1 libxss1 libxtst6 xdg-utils && \
    chmod 0755 /opt/godot/godot && \
    ln -sf /opt/godot/godot /usr/bin/godot && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/godot.png
COPY godot.desktop /usr/share/applications/godot.desktop
