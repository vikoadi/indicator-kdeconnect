#
# spec file for package indicator-kdeconnect
#
# Copyright (c) 2014 Markus S. <kamikazow@web.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

Name:           indicator-kdeconnect
Version:        0.1
Release:        0%{?dist}
Summary:        App Indicator for KDE Connect
Group:          Applications/System
License:        LGPL-2.1+
URL:            https://github.com/vikoadi/indicator-kdeconnect

# For this spec file to work, the sources must be located in a directory
# named indicator-kdeconnect-1.2.2 (with "1.2.2" being the version
# number defined above).
# If the sources are compressed in another format than .tar.xz, change the
# file extension accordingly.
Source0:        %{name}-%{version}.tar.xz

# Package names only verified with Fedora.
# Should the packages in your distro be named dirrerently,
# see http://en.opensuse.org/openSUSE:Build_Service_cross_distribution_howto
%if 0%{?fedora} || 0%{?rhel_version} || 0%{?centos_version}
BuildRequires:  cmake
BuildRequires:  gtk3-devel
BuildRequires:  libappindicator-gtk3-devel
BuildRequires:  vala
Requires:       kde-connect-libs
%endif

%if 0%{?suse_version}
BuildRequires:  cmake
BuildRequires:  gtk3-devel
BuildRequires:  libappindicator3-devel
BuildRequires:  vala
Requires:       kdeconnect-kde
%endif

%description
Indicator to make KDE Connect usable in desktops such as Ubuntu Unity and Pantheon.
A small program, kdeconnect-send, to help sending files from PC to Android is included.

%prep
%setup -q

%build
mkdir build
pushd build
%cmake .. -DCMAKE_INSTALL_PREFIX_PATH=%{_prefix}
make PREFIX=%{_prefix} %{?_smp_mflags}
popd

%install
pushd build
%{make_install}
popd

%files
%defattr(-,root,root,-)
%doc COPYING README.md
%{_bindir}/%{name}
%{_bindir}/kdeconnect-send
%{_datadir}/applications/%{name}.desktop
%{_datadir}/contractor/kdeconnect.contract
%{_datadir}/icons/hicolor/*/*/*
%{_datadir}/%{name}/*

%changelog
