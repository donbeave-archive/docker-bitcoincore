# Bitcoin Core (Docker)

[![Analytics](https://ga-beacon.appspot.com/UA-71075299-1/docker-awscli/main-page)](https://github.com/igrigorik/ga-beacon)

### Summary

Docker container with OpenVPN and Java 8 (JVM) inside, created to run java applications which need to use openvpn as a client.

### Docker image

https://hub.docker.com/r/donbeave/bitcoincore

#### How to use?

In your `Dockerfile` use the following:
```
FROM donbeave/bitcoincore

...
```

Copyright and license
---------------------

Copyright 2018 Alexey Zhokhov under the [Apache License, Version 2.0](LICENSE). Supported by [AZ][zhokhov].

[zhokhov]: http://www.zhokhov.com
