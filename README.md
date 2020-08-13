# Test Samba Share

This container allows to provide Samba shares whose content can be viewed with
a browser.

**WARNING:** This is **not** for production use. It's an insecure tool for
testing or development.


This tool is brought to you by [Scitotec](https://scitotec.de).

## License

- This project is under [MIT License](LICENSE)
- The wrapped [dperson/samba](https://hub.docker.com/r/dperson/samba) is under GNU Affero General Public License v3.0

## But... why?
If you have applications writing to a share, you might need a
fast way to control
- if something was written to the share and
- what was written to the share.

With this tool you can simply browse the shares of your stack without having to
access nasty samba shares deep inside the networks of your stack.

## How to use

There is only one thing to mention: the web-interface exposes `/shares/**`.
Therefore be sure to make each share, you want to view with your browser, a
sub-directory of `/shares`, e.g. `/shares/pics` and `/shares/movies`.

For all the rest: basically look up the docs of 
[dperson/samba](https://hub.docker.com/r/dperson/samba), as this tool just
wraps the web interface around it. You should be able to do anything you
can do with dperson/samba.

### Example 1

- two users (foo, bar), both with password `badpass`
- foo can access the share `pictures`
- bar can access the share `movies and stuff`
- the client needs to be compatible with Samba 3.x (highly optional, but may
  be useful to simulate production environments)

```bash
docker run -p 7080:80 -p 139:139 -p 445:445 scitotec/test-samba-share \
    -p \
    -u 'foo;badpass' \
    -u 'bar;badpass' \
    -s 'pics;/shares/pics;no;no;no;foo' \
    -s 'movies and stuff;/shares/movies;no;no;no;bar' \
    -g 'server min protocol = SMB3_00'
```

### Example 2

This is a more real-life example, using the same setup as in Example 1.

We use create a compose service providing two shares to be used from within
our stack. Other stack services can access the shares via, e.g.
`\\myshares\pics` and you can observe changes by accessing the exposed
web interface.

The configuration:
```yaml
version: '3.4'

volumes: 
    data_myshares:

services:
    myshares:
        image: scitotec/test-samba-share
        ports: 
            # expose only the web-interface to debug your software
            - '7080:80'
        volumes: 
            # make shared data more persistant (optional)
            - data_myshares:/shares
        environment:
            # same demo settings as in Example 1
            - PERMISSIONS=true
            - USER1=foo;badpass
            - USER2=bar;badpass
            - SHARE1=pics;/shares/pics;no;no;no;foo
            - SHARE2=movies and stuff;/shares/movies;no;no;no;bar
            - GENERIC1=server min protocol = SMB3_00
    client:
        # this could be your software using the share
        image: dperson/samba:latest
        entrypoint: smbclient
```

Bring up the stack:
```bash
docker-compose up -d
```

Validate, that the service `client` can access the samba shares:
```bash
docker-compose run --rm client //myshares/pics -U foo -c 'ls'
```
