# Gunakan image Miniconda sebagai basis
FROM continuumio/miniconda3

# Set versi Python yang akan digunakan
ENV PYTHON_VERSION=3.11

# Install Python 3.10
RUN conda install -y python=3.10

# Install JupyterLab dan nb_conda_kernels untuk Python 3.10
RUN conda install -y jupyterlab nb_conda_kernels

# Install Python 3.11 environment
RUN conda create -n inda-py${PYTHON_VERSION} -y python=${PYTHON_VERSION} ipykernel

# Install Java JDK untuk PySpark
RUN apt update
RUN apt install -y openjdk-17-jdk
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Aktifkan environment Python 3.11 dan instal pustaka data science
RUN conda run -n inda-py${PYTHON_VERSION} pip install numpy pandas matplotlib seaborn scikit-learn statsmodels
RUN conda run -n inda-py${PYTHON_VERSION} pip install tensorflow
RUN conda run -n inda-py${PYTHON_VERSION} pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN conda run -n inda-py${PYTHON_VERSION} pip install pyspark

# Bersihkan cache APT
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# semua kode di direktori /jupyterlab

RUN mkdir /jupyterlab
RUN chmod -R 777 /jupyterlab
WORKDIR "/jupyterlab"

# Salin file konfigurasi Jupyter (jika ada)
# COPY jupyter_notebook_config.py /root/.jupyter/

# Atur entrypoint untuk menjalankan JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=12345"]
