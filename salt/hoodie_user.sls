hoodie:
    user.present:
        - shell: /bin/bash
        - home: /home/hoodie

/etc/security/limits.conf:
    file.append:
        - text:
            - "hoodie    soft    nofile    768"
            - "hoodie    hard    nofile    1024"
