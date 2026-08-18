NEXTCLOUD_VERSION := 33.0.8

.PHONY: setup
setup:
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/server.git
	cd server && git submodule update --init
	mkdir server/data
	chmod 770 server/data
	docker compose run --rm -v ./server:/app/web --entrypoint bash --workdir /app/web/apps/photos nextcloud -c 'chown 33 /app/web/data'
	chmod 777 server/config
	chmod 777 server/apps
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/activity.git server/apps/activity
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/app_api server/apps/app_api
# 	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/support server/apps/support
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/survey_client server/apps/survey_client
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/text server/apps/text
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/twofactor_totp server/apps/twofactor_totp

	docker compose run --rm -v ./server:/app/web --entrypoint bash --workdir /app/web/apps/twofactor_totp nextcloud composer install

	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/bruteforcesettings server/apps/bruteforcesettings
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/circles server/apps/circles
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/files_downloadlimit server/apps/files_downloadlimit
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/files_pdfviewer server/apps/files_pdfviewer
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/firstrunwizard server/apps/firstrunwizard
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/logreader server/apps/logreader
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/nextcloud_announcements server/apps/nextcloud_announcements
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/notifications server/apps/notifications
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/password_policy server/apps/password_policy
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/photos server/apps/photos

	docker compose run --rm -v ./server:/app/web --entrypoint bash --workdir /app/web/apps/photos nextcloud /usr/local/bin/composer install

	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/privacy server/apps/privacy
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/recommendations server/apps/recommendations
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/related_resources server/apps/related_resources
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/serverinfo server/apps/serverinfo
	git clone --depth 1 --branch v$(NEXTCLOUD_VERSION) https://github.com/nextcloud/viewer server/apps/viewer

.PHONY: eurooffice
eurooffice:
	git clone https://github.com/Euro-Office/eurooffice-nextcloud.git server/apps/eurooffice
	cd server/apps/eurooffice && git submodule update --init --recursive
	cd server/apps/eurooffice && npm install
	cd server/apps/eurooffice && npm run build
	cd server/apps/eurooffice && composer-2.7.6 install
