module OrderStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :state do
      state :cart, initial: true
      state :address, :delivery, :payment, :confirm, :complete, :in_waiting,
            :in_progress, :in_delivery, :delivered, :canceled

      after_all_transitions :set_prev_state!

      event :address_step do
        transitions from: [:cart, :confirm], to: :address
      end

      event :delivery_step do
        transitions from: [:address, :confirm], to: :delivery
      end

      event :payment_step do
        transitions from: [:delivery, :confirm], to: :payment
      end

      event :confirm_step do
        transitions from: [:address, :delivery, :payment], to: :confirm
      end

      event :complete_step do
        transitions from: :confirm, to: :complete
      end

      event :in_waiting_step do
        transitions from: :complete, to: :in_waiting
      end

      event :in_progress_step do
        transitions from: :in_waiting, to: :in_progress
      end

      event :in_delivery_step do
        transitions from: :in_progress, to: :in_delivery
      end

      event :delivered_step do
        transitions from: :in_delivery, to: :delivered
      end

      event :canceled_step do
        transitions from: [
          :cart, :address, :delivery, :payment, :confirm, :complete,
          :in_waiting, :in_progress, :in_delivery, :delivered
        ], to: :canceled
      end
    end

    def next_state
      return prev_state if prev_state == 'confirm' && state != 'complete'
      return 'complete' if confirm?
      aasm.states(permitted: true).map(&:name).first.to_s
    end
  end
end
