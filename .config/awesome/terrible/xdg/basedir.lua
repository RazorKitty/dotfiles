local utils = require('terrible.utils')

return {
    data_home = (os.getenv('XDG_DATA_HOME') or os.getenv('HOME')..'.local/share'),
    config_home = (os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME')..'/.config'),
    data_dirs = utils.split(os.getenv('XDG_DATA_DIRS') or '/usr/local/share:/usr/share',':'),
    config_dirs = utils.split(os.getenv('XDG_CONFIG_DIRS') or '/etc/xdg',':'),
    cache_home = (os.getenv('XDG_CACHE_HOME') or os.getenv('HOME')..'.cache'),
    runtime_dir = os.getenv('XDG_RUNTIME_DIR')
}

