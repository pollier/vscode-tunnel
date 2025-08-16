FROM    ubuntu:noble

SHELL   ["/bin/bash", "-o", "pipefail", "-c"]
ENV     TZ=Europe/Paris
RUN     echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV     DEBIAN_FRONTEND=noninteractive

RUN     apt-get update \
  &&      apt-get install -y --no-install-recommends \
  acl \
  apache2-utils \
  apt-transport-https \
  apt-utils \
  aria2 \
  automake \
  base-files \
  bash \
  bat \
  bc \
  binutils \
  bsdmainutils \
  bsdutils \
  btrfs-progs \
  build-essential \
  bzip2 \
  ca-certificates \
  coreutils \
  curl \
  dash \
  diffutils \
  docker-buildx \
  docker-compose \
  docker.io \
  ethtool \
  file \
  findutils \
  fio \
  fonts-dejavu-core \
  g++ \
  gawk \
  gettext \
  gettext-base \
  git \
  gnupg \
  gnupg-agent \
  gpg \
  grep \
  gzip \
  hostname \
  htop \
  httpie \
  hugo \
  iotop \
  iproute2 \
  iputils-ping \
  j2cli \
  jq \
  lbzip2 \
  less \
  libmysqlclient-dev \
  locales \
  lsb-release \
  make \
  mysql-client \
  nano \
  ncdu \
  netbase \
  nmap \
  numactl \
  openssh-client \
  openssl \
  p7zip \
  patch \
  pigz \
  podman \
  postgresql-client \
  pv \
  python-is-python3 \
  python3-dev \
  python3-pip \
  python3-virtualenvwrapper \
  rclone \
  rsync \
  s3cmd \
  shellcheck \
  silversearcher-ag \
  skopeo \
  snapd \
  software-properties-common \
  sudo \
  tar \
  tmux \
  tree \
  tzdata \
  unrar \
  unzip \
  util-linux \
  uuid-runtime \
  wget \
  yamllint \
  zfsutils-linux \
  zip \
  zsh \
  zstd \
  &&      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg \
  &&      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  &&      chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  &&      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  &&      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list > /dev/null \
  &&      apt-get update \
  &&      apt-get install -y --no-install-recommends gh nodejs \
  &&      apt update \
  &&      apt upgrade -y \
  &&      apt-get autoremove --purge -y \
  &&      rm -rf /var/lib/apt/lists/*


RUN     userdel -r ubuntu

RUN     useradd -m -d /home/ubuntu -s /bin/zsh -u 1000 ubuntu && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu

COPY    --chown=ubuntu:ubuntu zshrc /home/ubuntu/.zshrc

USER    ubuntu

RUN     NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"=value
ENV     PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

RUN     brew update && brew upgrade && brew cleanup

USER root

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=ghcr.io/mccutchen/go-httpbin /bin/go-httpbin /bin/httpbin
RUN chmod +x /bin/httpbin
RUN curl  -L --output /code.tar.gz "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64"
RUN tar xvf /code.tar.gz
RUN mv code /bin/code
RUN chmod +x /bin/code
RUN rm -f code.tar.gz

RUN chsh -s /bin/zsh ubuntu

USER ubuntu

WORKDIR /home/ubuntu
ENV VSCODE_CLI_USE_FILE_KEYCHAIN=1
ENV VSCODE_CLI_DISABLE_KEYCHAIN_ENCRYPT=1

RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.zshrc" SHELL="$(which zsh)" zsh -

EXPOSE 8000
COPY --chown=ubuntu:ubuntu tunnel.sh /home/ubuntu/tunnel.sh
RUN chmod +x /home/ubuntu/tunnel.sh

CMD ["/home/ubuntu/tunnel.sh"]

# https://github.com/microsoft/vscode/issues/170013#issuecomment-1787378725
