---
title: ufo apps
reference: true
---

## Usage

    ufo apps

## Description

List apps.

This command lists ECS services for an ECS cluster. It includes ECS services that were not created by ufo also.  A `Ufo?` column value of `yes` indicates that the ECS service was created by ufo version 4 and above.  If the service was created with ufo version 3 and below then it will show up as `no`.

## Examples

    $ ufo apps
    Listing ECS services in the development cluster.
    +--------------------------------------------------+-----------------+---------+-------------+------+
    |                   Service Name                   | Task Definition | Running | Launch type | Ufo? |
    +--------------------------------------------------+-----------------+---------+-------------+------+
    | development-demo-web-Ecs-7GAUAXH5F56M (demo-web) | demo-web:85     | 2       | FARGATE     | yes  |
    +--------------------------------------------------+-----------------+---------+-------------+------+
    $


## Options

```
[--clusters=one two three]   # List of clusters
[--verbose], [--no-verbose]  
[--mute], [--no-mute]        
[--noop], [--no-noop]        
[--cluster=CLUSTER]          # Cluster.  Overrides .ufo/settings.yml.
```

