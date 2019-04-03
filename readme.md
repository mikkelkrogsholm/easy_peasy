# Easy peasy massive parallel computing in R

Wouldn’t it be nice to be able to write simple R-code that very simply scales to massive parallel computing?

The `future` and the `furrr` package in R provides a framework that makes it possible for you to write code, that works seamlessly on your laptop or on a supercomputer. With these packages, R expressions can be evaluated on the local machine, in parallel on a set of local machines, or distributed on a mix of local and remote machines.

There is no need to modify any code in order switch from sequential on the local machine to distributed processing on a remote compute cluster. Global variables and functions are also automatically identified and exported as needed, making it straightforward to tweak existing code to make use of futures.

This repository holds the code for the presentation on this topic. The presentation shows you how. It will run through a concrete example that is first executed on a local machine and then on a much more powerful server.

## Docker image
In order to make sure that every thing is working as intended a docker image is created.

It is based on the `rocker/tidyverse:3.5.3` image then it adds the `future`, `furrr`, `prophet` and the `gapminder` packages.

Finally it copies some R files to the image that are used to demo the functionality.


### How to
Build the image (No cache)
```
docker build --no-cache -t mikkelkrogsholm/easy_peasy .
```

Build the image (Cached)
```
docker build -t mikkelkrogsholm/easy_peasy .
```

Push to dockerhub
```
docker push mikkelkrogsholm/easy_peasy
```

Run the docker without shared volume (recommended)
```
docker run --rm -p 8787:8787 -e PASSWORD=mikkel -e USER=mikkel mikkelkrogsholm/easy_peasy
```

Run the docker with shared volume (recommended)
```
docker run --rm -p 8787 -v $PWD/:/home/mikkel -e PASSWORD=mikkel -e USER=mikkel mikkelkrogsholm/easy_peasy
```
