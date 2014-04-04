{% set home = pillar.env.HOME %}
git-core:
    pkg.installed

{{ pillar.git_clone_url }}:
    git.latest:
        - rev: {{ pillar.get('branch', 'master') }}
        - target: {{ home }}
        - runas: hoodie
        - require:
            - pkg: git-core
            - user: hoodie

npm install:
    cmd.wait:
        - user: hoodie
        - cwd: {{ home }}
        - watch:
            - git: {{ pillar.git_clone_url }}

{% if 'build_cmd' in pillar %}
{{ pillar.build_cmd }}:
    cmd.wait:
        - user: hoodie
        - cwd: {{ home }}
        - watch:
            - git: {{ pillar.git_clone_url }}
{% endif %}

hoodie_app:
    file.managed:
        - name: /etc/init/hoodie_app.conf
        - template: jinja
        - source: salt://hoodie_app/hoodie_app.conf.jinja
        - mode: 600
        - defaults:
            env: {{ pillar.env }}
    service.running:
        - enable: True
        - watch:
            - cmd: npm install
            - file: hoodie_app
        - require:
            - cmd: npm install
            - file: hoodie_app

ssl_cert:
    module.run:
        - name: tls.create_self_signed_cert
        - tls_dir: {{ pillar.domain }}
        - CN: {{ pillar.domain }}
        - emailAddress: webmaster@{{ pillar.domain }}


/etc/nginx/sites-enabled/default:
    file.absent

/etc/nginx/sites-available/hoodie.conf:
    file.managed:
        - template: jinja
        - source: salt://hoodie_app/nginx.conf.jinja
        - defaults:
            home: {{ pillar.env.HOME }}
            domain: {{ pillar.domain }}
            hoodie_url: http://127.0.0.1:6001
        - require:
            - pkg: nginx
        - watch_in:
            - service: nginx

/etc/nginx/sites-enabled/hoodie.conf:
    file.symlink:
        - target: /etc/nginx/sites-available/hoodie.conf
        - require:
            - pkg: nginx
            - file: /etc/nginx/sites-available/hoodie.conf
            - module: ssl_cert
        - watch_in:
            - service: nginx
