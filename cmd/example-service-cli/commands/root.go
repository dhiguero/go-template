package commands

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:     "example-service-cli",
	Short:   "Example service CLI",
	Long:    `Example service CLI`,
	Version: "TBD",
	Run: func(cmd *cobra.Command, args []string) {
		cmd.Help()
	},
}

// Execute the user command
func Execute(version string, commit string) {
	versionTemplate := fmt.Sprintf("version: %s commit: %s", version, commit)
	rootCmd.SetVersionTemplate(versionTemplate)
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
