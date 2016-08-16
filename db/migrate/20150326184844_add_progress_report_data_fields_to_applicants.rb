class AddProgressReportDataFieldsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :approved_irb_protocols, :text
    add_column :applicants, :approved_irb_document, :string
    add_column :applicants, :approved_iacuc_protocols, :text
    add_column :applicants, :approved_iacuc_document, :string
  end
end
