{
	description = "My vault-demo environment.";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"; # "github:NixOS/nixpkgs/nixos-unstable"
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = {
		self,
		nixpkgs,
		flake-utils,
		...
	}:
	flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs = import nixpkgs {
				inherit system;
				pkgs = nixpkgs.legacyPackages.${system};
				config.allowUnfree = true;
			};
		in rec {
			devShell = pkgs.mkShell {
				packages = with pkgs; [
                    gh
                    git-filter-repo

                    # note: must the cmd 'code .' from this shell
					vscode-fhs # needed for C# Extensions & Debugging
					dotnetCorePackages.dotnet_9.sdk # includes the runtime
                    nodejs_24

                    openssl

					terraform
                    awscli2

                    python3
					ansible
				];

				shellHook = ''
					echo "Starting new shell";
					export ANSIBLE_CONFIG="ansible/ansible.cfg"
                    export AWS_SDK_LOAD_CONFIG="1"
					export DOTNET_ROOT="${pkgs.dotnetCorePackages.dotnet_9.sdk}/share/dotnet"
					export DOTNET_BIN="${pkgs.dotnetCorePackages.dotnet_9.sdk}/bin/dotnet"
				'';
			};
		}
	);
}
