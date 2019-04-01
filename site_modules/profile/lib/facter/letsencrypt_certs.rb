Facter.add('letsencrypt_certs') do
  confine :kernel => 'Linux'
  setcode do
    certs = []
    if File.directory?('/etc/letsencrypt/live')
      dirs = Dir.entries('/etc/letsencrypt/live').select do |e|
        File.directory?(File.join('/etc/letsencrypt/live', e)) && !(entry =='.' || entry == '..')
      end
      dirs.each do |d|
        if File.exists?(File.join(d, 'cert.pem'))
          certs << File.basename(d)
        end
      end
    end
    certs
  end
end
