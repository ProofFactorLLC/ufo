---
title: ufo task
reference: true
---

## Usage

    ufo task TASK_DEFINITION

## Description

Run a one-time task.

The `ufo task` commands:

1. Builds the docker image
2. Registers the ECS task definition
3. Runs the command

## Examples

You can use the `--command` or `-c` option to override the Docker container command.

    ufo task hi-migrate # default command
    ufo task demo-web --command bin/migrate
    ufo task demo-web --command bin/with_env bundle exec rake db:migrate:redo VERSION=xxx
    ufo task demo-web -c uptime
    ufo task demo-web -c pwd

## Skipping Docker and Task Registration

The `--task-only` option is useful. By default, the `ufo task` command will build the docker image and then register a new task definition.  The docker build process usually is the part that takes the most time. You can skip the docker build process after building it at least once.  This is a faster way to run a bunch of commands with the same Docker image. Example:

    ufo task demo-web -c uptime # build at least once
    ufo task demo-web --task-only -c ls # skip docker for speed
    ufo task demo-web --task-only -c pwd # skip docker for speed

## Params

You can control and customize the params that get sent to the ECS run_task call with a `config/params.yml` file. More info here: https://ufoships.com/docs/ufo-task-params/


## Options

```
    [--task-only], [--no-task-only]  # Skip docker and task register steps. Only run the task.
w, [--wait], [--no-wait]             # Wait for task to finish.
t, [--timeout=N]                     # How long to wait for task to finish.
                                     # Default: 600
c, [--command=one two three]         # Override the command used for the container
    [--verbose], [--no-verbose]      
    [--mute], [--no-mute]            
    [--noop], [--no-noop]            
    [--cluster=CLUSTER]              # Cluster.  Overrides .ufo/settings.yml.
```

