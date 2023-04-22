defmodule WebpexWeb.API.V1.APIJSON do

  def create(%{filename: filename}) do
    %{id: filename}
  end

  def error(%{error: error}) do
    %{error: error}
  end

end
