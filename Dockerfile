FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装必要依赖
RUN apt update && apt install -y \
    fuse libgl1 libxrender1 libxext6 libfuse2 \
    wget curl ca-certificates \
    && apt clean

# 设置工作目录
WORKDIR /root

# 复制已准备好的 AppImage 文件（由你通过 GitHub Actions 下载）
COPY FreeCAD.AppImage .

# 解压 AppImage
RUN chmod +x FreeCAD.AppImage && ./FreeCAD.AppImage --appimage-extract \
    && rm FreeCAD.AppImage \
    #解压后删了

# 下载并使用 AppImage 的 Python 安装 pip
RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py && \
    ./squashfs-root/usr/bin/python get-pip.py && \
    rm get-pip.py

# 注册 AppImage 的 Python 为全局命令
RUN ln -sf /root/squashfs-root/usr/bin/python /usr/local/bin/python && \
    echo '#!/bin/bash' > /usr/local/bin/pip && \
    echo '/root/squashfs-root/usr/bin/python -m pip "$@"' >> /usr/local/bin/pip && \
    chmod +x /usr/local/bin/pip

# 设置 FreeCAD 模块所需的路径
ENV PYTHONPATH=/root/squashfs-root/usr/lib/python3.11/site-packages:/root/squashfs-root/usr/lib:$PYTHONPATH
ENV LD_LIBRARY_PATH=/root/squashfs-root/usr/lib:$LD_LIBRARY_PATH

# 安装 Python 库
RUN pip install fastapi uvicorn

# 默认启动 Python（可改为 Web 服务入口）
CMD ["python"]
