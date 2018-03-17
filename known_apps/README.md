# Known Applications

By default Shipyard searches for the data of the applications with the help of [QStandardPaths](https://doc.qt.io/qt-5/qstandardpaths.html) class in accordance with the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html). Most of the SailFish OS applications use the [Sailfish Application Library](https://github.com/sailfishos/libsailfishapp) which means that an abstract application `harbour-foobar` uses next paths:

Type          | Path
-------------:|-----------------------------------------
Configuration | `/home/nemo/.config/harbour-foobar`
Cache         | `/home/nemo/.cache/harbour-foobar`
Local Data    | `/home/nemo/.local/share/harbour-foobar`

But some applications use custom paths and Shipyard should know where to search their files. To add such an application one must write a special configuration file and place it to the **harbour-shipyard/generator/known_apps** directory.

## Configuration file

### Structure

The configuration file for a known application is an **ini** file with the folowing structure:

1. A group name which is handled as the application **.desktop** file. It's used to detect if the application is installed.
2. A set of key/value options where value is a comma separated list of the application directories and files.

Key          | Value
------------:|--------------------------------
`config`     | A list of configuration entries
`cache`      | A list of cache entries
`local_data` | A list of local data entries

**Note:** although each of these options is not mandatory, at least one of them must be specified.

### Example

```ini
[foobar]
config=/home/nemo/.config/foo/bar.conf, /home/nemo/.config/foo/bar2.conf
cache=/home/nemo/.cache/foo/bar/
local_data=/home/nemo/.foobar/
```
