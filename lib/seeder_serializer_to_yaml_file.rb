module SeederSerializerToYamlFile
  def file_path
    ""
  end

  def file_name
    ""
  end

  def to_yaml_file
    File.write("#{file_path}/#{file_name}.yml", self.as_json.to_yaml) unless file_name.blank? || file_path.blank?
    file_name
  end

  def get_yaml_files
    return [] unless Dir.exists?(file_path)
    Dir.entries(file_path).inject([]) do |arr, file|
      arr << file unless file[0] == '.'
      arr
    end
  end
end