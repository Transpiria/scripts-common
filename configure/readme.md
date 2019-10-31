# Configure

This script helps configure file based configuration systems via commandline. This can prevent the need for custom docker images that only change configuration.

## Arguments

|Argument|Occurances|Description|Example|
|---|---|---|---|
|--file|multiple|Sets the current file to be configured|`--file /etc/system.conf`|
|--group-root|multiple|Begins a root level configuration group for the current file|`--group-root [config-group]`|
|--group|multiple|Begins a configuration group for the current group|`--group [sub-config-group]`|
|--val|multiple|Sets the key to the value|`--val key value`|
|--str|multiple|Sets the key to the string value|`--str key value`|
|--run|single|Runs the following command with it's following arguments|`--run echo hello world`|

## Full Example

Command:

```bash
./configure.sh \
  --file /etc/system.conf \
    --group-root [agent] \
      --str interval 10s \
      --val debug false \
    --group-root [inputs] \
      --val collect true \
      --group [tags] \
        --str Application my-application \
        --str host \$HOSTNAME \
```

Resulting file:

```config
[agent]
  interval = "10s"
  debug = false
[inputs]
  collect = true
  [tags]
    Application = "my-application"
    host = "$HOSTNAME"
```
