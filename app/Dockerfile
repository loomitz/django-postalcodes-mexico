# Etapa de construcción
FROM python:3.12-slim-bullseye AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/app

# Instalamos las dependencias necesarias para compilar psycopg2
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalamos las herramientas de construcción
RUN pip install --no-cache-dir pip wheel setuptools

# Copiamos los requerimientos y generamos wheels
COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt

# Etapa final
FROM python:3.12-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/usr/src/app:/usr/src

WORKDIR /usr/src/app

# Instalamos libpq5 que es necesario para psycopg2 en runtime
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq5 \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Copiamos los wheels y el código fuente
COPY --from=builder /usr/src/app/wheels /wheels
COPY . /usr/src/app/

# Instalamos las dependencias
RUN pip install --no-cache-dir /wheels/* \
    && rm -rf /wheels \
    && rm -rf /root/.cache/pip/* \
    && chmod +x /usr/src/app/start.sh

# Comando para iniciar la aplicación
CMD ["/usr/src/app/start.sh"]