platform "windowsfips-2012r2-x64" do |plat|
  plat.vmpooler_template 'win-2012r2-fips-x86_64'
  plat.servicetype 'windows'

  # We need to ensure we install chocolatey prior to adding any nuget repos. Otherwise, everything will fall over
  plat.add_build_repository "https://artifactory.delivery.puppetlabs.net/artifactory/generic/buildsources/windows/chocolatey/install-chocolatey.ps1"
  plat.provision_with "C:/ProgramData/chocolatey/bin/choco.exe feature enable -n useFipsCompliantChecksums"

  plat.add_build_repository "https://artifactory.delivery.puppetlabs.net/artifactory/api/nuget/nuget"

  # We don't want to install any packages from the chocolatey repo by accident
  plat.provision_with "C:/ProgramData/chocolatey/bin/choco.exe upgrade -y chocolatey --no-progress"
  plat.provision_with "C:/ProgramData/chocolatey/bin/choco.exe sources remove -name chocolatey"

  #FIXME we need Fips Compliant Wix, currently not in choco repositories
  #plat.provision_with "C:/ProgramData/chocolatey/bin/choco.exe install -y Wix310 -version 3.10.2 -debug -x86 --no-progress"
  plat.provision_with "curl -L -o /tmp/wix314-binaries.zip https://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/buildsources/wix314-binaries.zip && \"C:/Program Files/7-Zip/7z.exe\" x -y -o\"C:/Program Files (x86)/WiX Toolset v3.14/bin\" C:/cygwin64/tmp/wix314-binaries.zip && rm /tmp/wix314-binaries.zip && SETX WIX \"C:\\Program Files (x86)\\WiX Toolset v3.14\" /M"

  plat.install_build_dependencies_with "C:/ProgramData/chocolatey/bin/choco.exe install -y --no-progress"

  plat.make "/usr/bin/make"
  plat.patch "TMP=/var/tmp /usr/bin/patch.exe --binary"

  plat.platform_triple "x86_64-w64-mingw32"

  plat.package_type "msi"
  plat.output_dir "windowsfips"
end
