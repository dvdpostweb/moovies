# Plush

[![wercker status](https://app.wercker.com/status/92bce29162ac58738c941c0bee761c52/s/ "wercker status")](https://app.wercker.com/project/byKey/92bce29162ac58738c941c0bee761c52)

Plush is a cloud-enabled, mobile-ready, application for watching movies.

# What we use?

  - Angular 2
  - Rails 3
  - Mysql
  - Bootstrap
  - Sphinx
  - Webpack

# production!

  - plush.be
  - plush.lu

# staging!

  - staging.plush.be
  - staging.plush.lu
  
# Deploys

  - cap staging deploy && cap staging invoke:rake TASK=webpack:compile
  - cap production deploy && cap production invoke:rake TASK=webpack:compile

# Deploys with Sphinx reindex

  - cap staging deploy && cap staging invoke:rake TASK=webpack:compile && cap staging invoke:rake TASK=ts:index
  - cap production deploy && cap production invoke:rake TASK=webpack:compile && cap staging invoke:rake TASK=ts:index
  
# Db access

  - ssh -i ~/.ssh/id_rsa -L 3307:192.168.100.204:3306 plush@217.112.190.50 -p 23051

# Filesystem access

  - ssh -i ~/.ssh/id_rsa plush@217.112.190.50 -p 23051
