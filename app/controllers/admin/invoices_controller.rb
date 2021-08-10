class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    @invoice = Invoice.find(params[:id])

    if params["invoice"]['status'] == 'completed'
      @invoice.update(status: params["invoice"]['status'])
      @invoice.update_invoice_items(@invoice.invoice_items)

      redirect_to admin_invoice_path(@invoice.id)
    else
      @invoice.update(status: params["invoice"]['status'])

      redirect_to admin_invoice_path(@invoice.id)
    end
  end
end
