# godot-csv-data
Utility for loading data from CSVs into classes and properly typing the data.

While working on RPGs I found it useful to be able to use a spreadsheet editor to work with stats, rather than having to navigate to different scenes in the godot editor. Loading CSVs into dictionaries is easy enough, but then you need to write a bunch of special-case code to convert strings into integers, strings, etc. The DataRow class handles this without too much effort; you simply create a class that inherits from DataRow and add vars to it with type hints, and call the init function in your constructor to automatically convert a dictionary you got from a CSV row into a fully type hinted object. It also correctly handles textures and scenes, calling `load` on the provided string.

In short, it lets you do refactors like [this](https://github.com/EamonnMR/mpevmvp/commit/11b095db8ad2501004d96159564bc4a4224ef6a8#diff-555d0a29a33b6d4cde4e4953db393e307e5147cd609d979cafb14e02d9fda144L97), or [this](https://github.com/EamonnMR/mpevmvp/commit/1a9ff71966ac54b428cbe30e2ab5d36eff04af29#diff-555d0a29a33b6d4cde4e4953db393e307e5147cd609d979cafb14e02d9fda144L139). 

Pulled out of https://github.com/EamonnMR/mpevmvp search that project for DataRow to see an example of how it's used. If you check out 
