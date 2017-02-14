# nginx-proxy

This is a basic puppet + nginx as a proxy setup demonstration that allows you to do the following in a local Vagrant environment:

**1)** Create a puppet managed nginx node that serves a simple web page with an image

**2)** Create a puppet managed nginx proxy node that proxies all requests to a ‘set’ of backend web server nodes. These nodes may be one or more of the nodes you’ve created in the first step above.

**Steps:**

Make sure that **Vagrant** is installed on your local machine. I’m assuming OSX here. Then use the appropriate commands (e.g. `vagrant up`) to bring up the machines.

For the puppet master, use:

`vagrant up ppmaster`

This will give you a new Debian **Jessie** box, and we need to install the puppet server as follows:

`apt-get install puppetmaster-passenger`

We now need to setup the puppet master’s configuration, and copy our node and module configuration into the right place. The files we need to update are `puppet.conf` and `autosign.conf`. 

The master automatically looks for it’s manifests like `site.pp` in the `/etc/puppet/manifests` directory so we need to copy the `site.pp` into the directory, as well as the `nodes` and `modules` directories.

All of this can be checked out using Github directly onto the puppet master, or you can copy things manually.

Once you’ve got the puppet master running with all the modules in the right place, you can go ahead and create the first web node, `web1`:

`vagrant up web1`

This will use the commands in `bootstrap.sh` to automatically install puppet and add the IP of the puppet master in the `/etc/hosts` file. If the IP of your puppet master is different for any reason, please update it here.

You can login to the web node using `vagrant ssh web1` then use `sudo -i` to become `root` and use `tail -f /var/log/syslog` to check if the puppet runs were successful, or you can run puppet yourself manually using `puppet agent -t`.

We need to test if the web node is indeed serving up our file properly. You can do this by installing something like `links` inside the machine locally and checking on `localhost`, or you can use SSH port forwarding as below:

`vagrant ssh web1 -- -L8000:localhost:80`

This will forward your local machine’s port `8000` to the guest VM's port `80`, allowing you to view the web page in your local browser at `http://localhost:8000`.

This completes our basic web server setup, now let’s setup the proxy.

Use the following to bring up the proxy server:

`vagrant up proxy1`

Use the same procedure as described above to check whether the puppet runs have completed successfully, then, use the following command to forward the local port `8080` to the guest VM’s port `80`:

`vagrant ssh proxy1 -- -L8080:localhost:80`

After that’s done, SSH to both the `web1` and `proxy1` machines, become `root` and run the following command to monitor the access logs of both machines:

`tail -f /var/log/nginx/access.log`

Now, send a request to your local machine on the port that `proxy1` is using - `8080`. This should forward the request to the **backend** web server, and you should see this happening in the access logs, for example:

**Proxy server:**
`root@proxy1# tail -f /var/log/nginx/access.log`

`::1 - - [14/Feb/2017:03:30:55 +0000] "GET / HTTP/1.1" 200 540 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36”`

**Web Server:**
`root@web1# tail -f /var/log/nginx/access.log`

`192.168.1.119 - - [14/Feb/2017:03:30:55 +0000] "GET / HTTP/1.0" 200 860 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36”`

As you can see, the access logs on the web server have the IP address of the proxy server in them - `192.168.1.119`, which is just as it should be.

You can now add even more machines, i.e. `web2`, `web3`, etc to the backend. Just define the machines in Vagrant, bring them up and run puppet on them. Then, edit the `nginx.conf` file on the `proxy1` machine (this is in puppet too), to add these new machines and you are all setup with a simple nginx proxy setup.

