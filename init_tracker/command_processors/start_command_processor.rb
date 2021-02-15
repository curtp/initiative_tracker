# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class StartCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if initiative_started?
          result[:success] = false
          result[:error_message] = "Initiative has already been started in this channel."
        else
          InitTracker::Models::Init.create(server_id: command.event.server.id, channel_id: command.event.channel.id)
          command.event << "Everyone roll initiative!\n"
          command.event << "To roll iniative use the command: **!init add '[character name]' [dice]**"
        end
        InitTrackerLogger.log.debug {"StartCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
