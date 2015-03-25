module SeederSerializerToYamlFile
  def file_path
    ""
  end

  def file_name
    ""
  end

  def to_yaml_file
    return unless valid_yaml_file?
    fname = sanitize_file_name
    File.write("#{file_path}/#{fname}.yml", self.as_json({root: false}).to_yaml) unless fname.blank? || file_path.blank?
    fname
  end

  def get_yaml_files
    return [] unless Dir.exists?(file_path)
    Dir.entries(file_path).inject([]) do |arr, file|
      arr << file unless file[0] == '.'
      arr
    end
  end

  def sanitize_file_name
    file_name.downcase.gsub(' ','_').gsub('.','').underscore if file_name
  end

  def valid_yaml_file?
    true
  end
end