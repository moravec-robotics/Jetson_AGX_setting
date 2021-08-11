#!/bin/bash

echo "[**********Install OpenCV 4.5.1 for CUDA, OpenCV_contrib**********]"
sudo sh -c "echo '/usr/local/cuda/lib64' >> /etc/ld.so.conf.d/nvidia-tegra.conf"
sudo ldconfig

echo ""
echo ""
echo "[**********Install Dependencies**********]"
sudo apt-get install -y build-essential cmake git 
sudo apt-get install -y unzip pkg-config 
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libgtk2.0-dev libcanberra-gtk* 
sudo apt-get install -y python3-dev python3-numpy python3-pip 
sudo apt-get install -y libxvidcore-dev libx264-dev libgtk-3-dev libtbb2 libtbb-dev libdc1394-22-dev libv4l-dev 
sudo apt-get install -y v4l-utils libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
sudo apt-get install -y libavresample-dev libvorbis-dev libxine2-dev libfaac-dev libmp3lame-dev 
sudo apt-get install -y libtheora-dev libopencore-amrnb-dev libopencore-amrwb-dev 
sudo apt-get install -y libopenblas-dev libatlas-base-dev libblas-dev liblapack-dev libeigen3-dev 
sudo apt-get install -y gfortran libhdf5-dev protobuf-compiler 
sudo apt-get install -y libprotobuf-dev libgoogle-glog-dev libgflags-dev

echo ""
echo ""
echo "[**********Download OpenCV**********]"
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.1.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.1.zip
unzip opencv.zip
unzip opencv_contrib.zip


mv opencv-4.5.1 opencv
mv opencv_contrib-4.5.1 opencv_contrib
rm opencv.zip
rm opencv_contrib.zip

echo ""
echo ""
echo "[**********Build OpenCV**********]"
cd ~/opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
-D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
-D WITH_OPENCL=OFF \
-D WITH_CUDA=ON \
-D CUDA_ARCH_BIN=5.3 \
-D CUDA_ARCH_PTX="" \
-D WITH_CUDNN=ON \
-D WITH_CUBLAS=ON \
-D ENABLE_FAST_MATH=ON \
-D CUDA_FAST_MATH=ON \
-D OPENCV_DNN_CUDA=ON \
-D ENABLE_NEON=ON \
-D WITH_QT=OFF \
-D WITH_OPENMP=ON \
-D WITH_OPENGL=ON \
-D BUILD_TIFF=ON \
-D WITH_FFMPEG=ON \
-D WITH_GSTREAMER=ON \
-D WITH_TBB=ON \
-D BUILD_TBB=ON \
-D BUILD_TESTS=OFF \
-D WITH_EIGEN=ON \
-D WITH_V4L=ON \
-D WITH_LIBV4L=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D BUILD_opencv_python3=TRUE \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D BUILD_EXAMPLES=OFF ..

make -j$(($(nproc)*2-2))

cd ~
sudo rm -r /usr/include/opencv4/opencv2
cd ~/opencv/build
sudo make install
sudo ldconfig
make clean
sudo apt-get update


echo ""
echo ""
echo "[**********Check Install**********]"
python3 -c "import cv2; print(cv2.__version__); print(cv2.cuda.getCudaEnabledDeviceCount())"
