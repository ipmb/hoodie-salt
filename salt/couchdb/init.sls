couchdb:
    pkg:
        - installed
    service.running:
        - enable: True
        - require:
            - pkg: couchdb

/etc/couchdb/local.d/hoodie.ini:
    file.managed:
        - source: salt://couchdb/hoodie.ini.jinja
        - template: jinja
        - user: couchdb
        - mode: 600
        - defaults:
            admin_user: {{ pillar.env.HOODIE_ADMIN_USER }}
            admin_password: {{ pillar.env.HOODIE_ADMIN_PASS }}
        - watch_in:
            - service: couchdb
