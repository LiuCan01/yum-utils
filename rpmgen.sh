#!/bin/bash

rpmbuild --define "_topdir `pwd`" --define "dist .el7.centos.es" -ba `pwd`/SPECS/yum-utils.spec
