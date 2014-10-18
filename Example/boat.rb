require "rubygems"
require "xcodeproj"
require "fileutils"

class XCodeStructGenerator
  def initialize(project_name)
    @project_path = `pwd`.sub("\n", "")
    puts "Current Project Path is #{@project_path}, please confirm it is correct. (Enther 'y')"
    if true #gets.chomp == "y"
      @project_name = project_name
      @project = Xcodeproj::Project.open("#{project_name}.xcodeproj")
      generate
    end
  end

  def main_group
    @project.groups[1]
  end

  def template_dir
    "/Users/bin/Codes/iphone/Boat/Template"
  end

  def add_file(group, file_path, file_template_dir = template_dir)
    unless File.exist?(file_path)
      file_name, file_dir = file_path.split("/")[-1], file_path.split("/")[0..-2].join("/")
      FileUtils.cp("#{file_template_dir}/#{file_name}", file_dir)
      file = File.new(file_path)
      x_file = group.new_file(file)
      @project.targets.first.add_file_references([x_file]) if file_name =~ /\.m$/
    end
  end

  def find_or_add_group(group_name, parent_group)
    parent_group.groups.select { |g| g.name.to_s == group_name }[0] || parent_group.new_group(group_name)
  end

  def generate
    ["Controller", "Models", "Views", "Libs", "Public"].each do |group_name|
      real_dir_path = "#{@project_path}/#{@project_name}/#{group_name}"
      unless File.directory?(real_dir_path)
        FileUtils::mkdir_p(real_dir_path)
      end

      group = self.find_or_add_group(group_name, main_group)
      case group_name
      when "Controller"
        controller_group = self.find_or_add_group("HelloWorld", group)
        self.add_file(controller_group, "#{real_dir_path}/HelloWorldController.h")
        self.add_file(controller_group, "#{real_dir_path}/HelloWorldController.m")
      when "Views"
        view_group = self.find_or_add_group("HelloWorld", group)
        self.add_file(view_group, "#{real_dir_path}/HelloWorldView.h")
        self.add_file(view_group, "#{real_dir_path}/HelloWorldView.m")
      when "Public"
        ["Stylesheets", "Images"].each do |g_name|
          _group = self.find_or_add_group(g_name, group)
          case g_name
          when "Images"
            FileUtils::mkdir_p("#{real_dir_path}/Images")
            `ls #{template_dir}/Images`.split("\n").each do |file|
              self.add_file(_group, "#{real_dir_path}/Images/#{file}", "#{template_dir}/Images")
            end
          when "Stylesheets"
            FileUtils::mkdir_p("#{real_dir_path}/Stylesheets")
            `ls #{template_dir}/Stylesheets`.split("\n").each do |file|
              self.add_file(_group, "#{real_dir_path}/Stylesheets/#{file}", "#{template_dir}/Stylesheets")
            end
          end
        end
      end
    end
    @project.save
  end
end

XCodeStructGenerator.new("Boat")
