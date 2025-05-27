#!/usr/bin/env bash

for encrypted_file in $(chezmoi managed --include encrypted --path-style absolute); do
	# optionally, add --force to avoid prompts
	chezmoi forget "$encrypted_file"

	# strip the .asc extension
	decrypted_file="${encrypted_file%.asc}"

	chezmoi add --encrypt "$decrypted_file"
done
