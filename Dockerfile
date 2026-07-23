ARG NAGINI_REF=1.2.0

FROM python:3.12-slim-bookworm AS base

ARG NAGINI_REF

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    JAVA_HOME=/usr/lib/jvm/default-java \
    Z3_EXE="/usr/local/bin/z3" \
    HOME=/home/naginiuser \
    PATH="/usr/lib/jvm/default-java/bin:${PATH}"

# Install Java 17 JRE, C compilation headers, and build utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre-headless \
    git \
    curl \
    ca-certificates \
    gcc \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade Python build tools and install pinned Z3 4.16.0 and Nagini with server, lsp, and mcp extras
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir z3-solver==4.16.0.0 && \
    if echo "${NAGINI_REF}" | grep -qE '^[0-9]+\.[0-9]+'; then \
        pip install --no-cache-dir "nagini[server,lsp,mcp]==${NAGINI_REF}"; \
    else \
        pip install --no-cache-dir "nagini[server,lsp,mcp] @ git+https://github.com/marcoeilers/nagini.git@${NAGINI_REF}"; \
    fi

# Purge build compilers to reduce attack surface and image size
RUN apt-get update && apt-get purge -y --auto-remove gcc python3-dev build-essential && rm -rf /var/lib/apt/lists/*

# Set up non-root user and home workspace
RUN useradd -m -u 1000 naginiuser && \
    mkdir -p /code /home/naginiuser/.local && \
    chown -R naginiuser:naginiuser /code /home/naginiuser

COPY --chown=naginiuser:naginiuser entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /code
USER naginiuser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--help"]
