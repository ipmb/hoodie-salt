A basic [Hoodie](http://hood.ie) server Salt formula that loosely follows the [deployment guide](https://github.com/hoodiehq/my-first-hoodie/blob/master/deployment.md).

Nginx is setup with a self-signed SSL certificate. For simplicity, Upstart is used instead of monit and logrotate.

Tested on Ubuntu 13.10, but may work on earlier versions as well.


## Setup

1. Create a pillar from the example and customize it for your app.
`cp pillar/hoodie.sls.example pillar/hoodie.sls && $EDITOR pillar/hoodie.sls`
2. Copy `pillar`, `salt`, and `hoodie_bootstrap.sh` to the `/srv` directory on the server where you'd like to deploy Hoodie.
3. `sudo /srv/hoodie_bootstrap.sh`


## Deploying

To deploy new code, simply re-run `sudo /srv/hoodie_bootstrap.sh` or call Salt directly, `sudo salt-call state.highstate --local`.
