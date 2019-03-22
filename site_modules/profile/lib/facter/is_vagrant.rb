Facter.add('is_vagrant') do
  confine :kernel => 'Linux'
  setcode do
    id_vagrant_code = Facter::Core::Execution.exec('/usr/bin/id vagrant &>/dev/null; echo $?').to_i
    is_vagrant = (id_vagrant_code == 0)
    is_vagrant
  end
end
