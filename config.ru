# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'unicorn/worker_killer'

use Unicorn::WorkerKiller::MaxRequests, 100, 120, true
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2)), 16
run Rails.application
