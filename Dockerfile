FROM alpine

# Env
ENV GIT_URL "https://github.com/Inrixia/Floatplane-Downloader"
ENV JUST_RUN N
ENV CONFIG_PATH="/config"
ENV USERNAME="$USERNAME"
ENV PASSWORD="$PASSWORD"
ENV REPEAT_SCRIPT="5m"
ENV MEDIA_PATH="/media"
ENV UID=1000
ENV GID=1000

# Copy 
COPY rootfs /

VOLUME /config

# Install required packages
RUN apk add -U build-base \
				libssl1.0 \
				curl \
				git \
				su-exec \
				s6 \
				python \
				nodejs \
				nodejs-npm \
				ffmpeg \
		# Set permissions
		&& chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
		# Cleanup
		&& apk del build-base \
		&& rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /floatplane/
WORKDIR /floatplane/

# install app dependencies + app
COPY package.json .
RUN npm install

COPY . .

# Execute
CMD ["run.sh"]