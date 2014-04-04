couchdb:
    pkg:
        - installed
    service.running:
        - enable: True
        - require:
            - pkg: couchdb
            - file: /etc/couchdb/local.d/0_hoodie.ini
            - file: /etc/couchdb/local.d/9_hoodie_auto_config.ini

# Our CouchDB config. CouchDB should never change it so
# changes to this file will trigger a restart
/etc/couchdb/local.d/0_hoodie.ini:
    file.managed:
        - source: salt://couchdb/hoodie.ini.jinja
        - template: jinja
        - user: couchdb
        - mode: 600
        - defaults:
            admin_user: {{ pillar.env.HOODIE_ADMIN_USER }}
            admin_password: {{ pillar.env.HOODIE_ADMIN_PASS }}
        - require:
            - pkg: couchdb
        - watch_in:
            - service: couchdb

# Create an empty file that is last in the config chain
# CouchDB will write any automated configs here
/etc/couchdb/local.d/9_hoodie_auto_config.ini:
    file.managed:
        - user: couchdb
        - mode: 600
        - require:
            - pkg: couchdb
