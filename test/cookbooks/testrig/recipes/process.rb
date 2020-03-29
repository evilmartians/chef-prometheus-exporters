file '/etc/process_exporter_test.yml' do
  content <<HERE
    process_names:
    - name: "{{.Comm}}"
      cmdline:
      - '.+'
HERE
end

process_exporter 'main' do
  config_path '/etc/process_exporter_test.yml'

  action %i(install enable start)
end
