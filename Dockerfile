FROM ubuntu:14.04

RUN adduser --system --home /var/lib/munin --shell /bin/false --uid 1103 --group munin

RUN set -xe \
    && apt-get update && RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y cron munin munin-node nginx apache2-utils wget heirloom-mailx patch rrdcached
RUN rm /etc/nginx/sites-enabled/default && mkdir -p /var/cache/munin/www && chown munin:munin /var/cache/munin/www && mkdir -p /var/run/munin && chown -R munin:munin /var/run/munin

ADD ./munin.conf /etc/munin/munin.conf
ADD ./nginx-munin /etc/nginx/sites-enabled/munin
ADD ./start-munin.sh /munin
ADD ./startrrd.sh /startrrd
ADD ./munin-graph-logging.patch /usr/share/munin
ADD ./munin-update-logging.patch /usr/share/munin

ADD ./muinin-graph /usr/bin/munin-graph
ADD ./munin-cron /usr/bin/munin-cron

RUN cd /usr/share/munin && patch munin-graph < munin-graph-logging.patch && patch munin-update < munin-update-logging.patch
COPY ./munin.cron /etc/cron.d/munin

VOLUME ["/etc/munin/munin-conf.d", "/var/log/munin", "/var/lib/munin", "/var/run/munin", "/var/cache/munin"]
RUN chown -R munin:munin /var/log/munin /var/lib/munin /var/run/munin /var/cache/munin
EXPOSE 8080
CMD ["bash", "/munin"]
