#!/bin/bash

# After mock 1.3.4, its implementation does not consider encoding well.
# So we may have UnicodeEncodeError problem if our locale is UTF-8 or something else.
# Our solution here is to force locale to be en_US and this is able to
# make following mock operations more general on any other machines.
export LANG=en_US

# The usage of this script should be:
#   $ ./rpmgen_mock.sh MOCK_CFG MOCK_CHROOT
#
#   MOCK_CFG: mock environment configuration file
#   MOCK_CHROOT: mock environment chroot directory
if [ ${#} -eq 2 ]; then
  MOCK_CFG=${1}
  MOCK_CHROOT=${2}
else
  echo ""
  echo "Usage: ${0} MOCK_CFG MOCK_CHROOT"
  echo ""
  echo "  MOCK_CFG		mock environment configuration file"
  echo "  MOCK_CHROOT		mock environment chroot directory"
  echo ""
  exit 1
fi

# Make sure that the RPMS and SRPMS directories do not exist.
rm -rf ./RPMS/ ./SRPMS/

# Use "mock --buildsrpm" and "mock --rebuild" to create package
# source rpm and binary rpm under mock environment.
# Note that whenever we issue "mock --buildsrpm" or "mock --rebuild",
# it will delete and recreate entire 'builddir' directory under chroot.
# so we have to copyout the SRPMS and RPMS from chroot after each mock operation.
/usr/bin/mock -r ${MOCK_CFG} --rootdir ${MOCK_CHROOT} --define "dist .el7.centos.es" --buildsrpm --spec ./SPECS/yum-utils.spec --sources ./SOURCES/
/usr/bin/mock -r ${MOCK_CFG} --rootdir ${MOCK_CHROOT} --copyout /builddir/build/SRPMS/ ./SRPMS/
/usr/bin/mock -r ${MOCK_CFG} --rootdir ${MOCK_CHROOT} --define "dist .el7.centos.es" --rebuild ./SRPMS/yum-utils-1.1.31-40.el7.centos.es.src.rpm
/usr/bin/mock -r ${MOCK_CFG} --rootdir ${MOCK_CHROOT} --copyout /builddir/build/RPMS/ ./RPMS/
