package config

import "github.com/rs/zerolog/log"

// ServiceConfig structure with all the options required by the service and service components.
type ServiceConfig struct {
	Version string
	Commit  string
}

// IsValid checks if the configuration options are valid.
func (sc *ServiceConfig) IsValid() error {
	return nil
}

// Print the configuration using the application logger.
func (sc *ServiceConfig) Print() {
	// Use logger to print the configuration
	log.Info().Str("version", sc.Version).Str("commit", sc.Commit).Msg("app config")
}
