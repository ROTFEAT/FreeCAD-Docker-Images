FROM ubuntu:24.04

RUN apt update && apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    && apt clean && rm -rf /var/lib/apt/lists/*

COPY FreeCAD.AppImage /opt/FreeCAD.AppImage
RUN chmod +x /opt/FreeCAD.AppImage && ln -s /opt/FreeCAD.AppImage /usr/local/bin/freecadcmd

ENV PYTHONPATH="/tmp/.mount_freeca*/usr/lib:$PYTHONPATH"

ENTRYPOINT ["/opt/FreeCAD.AppImage", "--console"]
