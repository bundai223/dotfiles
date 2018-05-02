#require "itamae/resource/base"
#require "shellwords"

module ::MItamae
  module Plugin
    module ResourceExecutor
      class Yaourt < ::MItamae::ResourceExecutor::Base
        def apply
          ensure_yaourt_availability

	  pre_action

	  case current.action
          when :install
            action_install
          when :update
            action_update
          when :remove
            action_remove
	  else
          end
        end

        private

        def pre_action
          case current.action
          when :install
            attributes.installed = true
          when :remove
            attributes.installed = false
          end
        end

        def set_current_attributes(current, action)
          current.installed = check_command(check_package_is_installed(attributes.name))

          if current.installed
            current.version = run_command(get_package_version(attributes.name)).stdout.strip
          end
        end

        def action_install(action_options)
          unless check_command(check_package_is_installed(attributes.name, attributes.version))
            run_command(install_package(attributes.name, attributes.version, attributes.options))
            updated!
          end
        end

        def action_update(action_options)
          run_command(update_package(attributes.options))
          updated!
        end

        def action_remove(action_options)
          if check_command(check_package_is_installed(attributes.name, nil))
            run_command(remove_package(attributes.name, attributes.options))
            updated!
          end
        end

        def ensure_yaourt_availability
          if run_command("which yaourt", error: false).exit_status != 0
            raise "`yaourt` command is not available. Please install yaourt."
          end
        end

        def check_package_is_installed(package, version=nil)
          if version
            grep = version.include?('-') ? "^#{escape(version)}$" : "^#{escape(version)}-"
            "yaourt -Q #{escape(package)} | awk '{print $2}' | grep '#{grep}'"
          else
            "yaourt -Q #{escape(package)} || yaourt -Qg #{escape(package)}"
          end
        end

        def install_package(package, version=nil, option='')
          "yaourt -S --noconfirm #{option} #{package}"
        end

        def remove_package(package, option='')
          "yaourt -R --noconfirm #{option} #{package}"
        end

        def update_package(option='')
          "yaourt -Syua --noconfirm #{option}"
        end

        def get_package_version(package, opts=nil)
          "yaourt -Qi #{package} | grep Version | awk '{print $3}'"
        end

        def escape(target)
          str = case target
                when Regexp
                  target.source
                else
                  target.to_s
                end

          Shellwords.shellescape(str)
        end
      end
    end
  end
end
