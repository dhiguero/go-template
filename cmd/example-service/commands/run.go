package commands

import (
	"github.com/dhiguero/go-template/internal/app/example-service/launch"
	"github.com/spf13/cobra"
)

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Launch the service",
	Long:  `Launch the service`,
	Run: func(cmd *cobra.Command, args []string) {
		s := launch.NewService(appConfig)
		s.Run()
	},
}

func init() {
	rootCmd.AddCommand(runCmd)
}
