package commands

import (
	"fmt"
	"os"

	"github.com/dhiguero/go-template/internal/app/example-service/config"
	"github.com/spf13/cobra"
)

var appConfig config.ServiceConfig

var rootCmd = &cobra.Command{
	Use:     "example-service",
	Short:   "Example service",
	Long:    `Example service`,
	Version: "TBD",
	Run: func(cmd *cobra.Command, args []string) {
		cmd.Help()
	},
}

// Execute the user command
func Execute(version string, commit string) {
	versionTemplate := fmt.Sprintf("version: %s commit: %s", version, commit)
	rootCmd.SetVersionTemplate(versionTemplate)
	appConfig.Version = version
	appConfig.Commit = commit
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
