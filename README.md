# vvv-provision-multi #

Multi site provision setup.

### Getting Started ###

Clone the repo as the site name into your `www` directory in vvv.

`git clone git@github.com:mrdink/vvv-provision-multi.git example.dev && rm -rf example.dev/.git`

* Add hosts to `vvv-config.yml` or `vvv-custom.yml`
* Update `vvv-hosts` and `vvv-nginx.conf`
* Run `vagrant up && vagrant provision`
