### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 5843337f-3a56-4712-b6b0-ee533beb6634
using PlutoHooks, HTTP

# ╔═╡ 054a9bfb-abed-4609-b060-e539809c00da
# TODO: ports and url as parameters
macro serve(func)
	cell_id = PlutoHooks.parse_cell_id(__source__.file |> string)

	quote
		handler_func = @use_ref($(esc(func)))

		@use_effect([$(esc(func))], $cell_id) do
			handler_func[] = $(esc(func))

			nothing
		end

		# TODO(paul): don't use @background and use close() on the http server
		# to prevent unexpected EADRINUSE also return error messages from outside the
		# task
		@background($cell_id) do
			HTTP.serve(req -> handler_func[](req))
		end
	end
end

# ╔═╡ 07415a82-7e95-4785-a0ea-c26034fa4b19
macro skip_as_script(ex)
	isdefined(Main, :PlutoRunner) ? esc(ex) : nothing
end

# ╔═╡ 9c46f6f6-515f-489d-aad0-1490409cb9d5
@skip_as_script import Pkg

# ╔═╡ b33204df-6e25-49aa-8ef9-b29bae9b380f
@skip_as_script Pkg.activate("..")

# ╔═╡ ba2e3bda-d0a0-4322-a1af-d8872ffb6acd
@skip_as_script @bind text html"<input placeholder='example http response...'>"

# ╔═╡ 9448a775-5b25-4f1c-8d14-57f700b298f4
@skip_as_script @serve (request) -> HTTP.Response(text)

# ╔═╡ e58648cd-d15f-4aab-bfc0-192cd7202e82
@skip_as_script HTTP.request("GET", "http://localhost:8081")

# ╔═╡ Cell order:
# ╠═07415a82-7e95-4785-a0ea-c26034fa4b19
# ╠═9c46f6f6-515f-489d-aad0-1490409cb9d5
# ╠═b33204df-6e25-49aa-8ef9-b29bae9b380f
# ╠═5843337f-3a56-4712-b6b0-ee533beb6634
# ╠═054a9bfb-abed-4609-b060-e539809c00da
# ╟─ba2e3bda-d0a0-4322-a1af-d8872ffb6acd
# ╠═9448a775-5b25-4f1c-8d14-57f700b298f4
# ╠═e58648cd-d15f-4aab-bfc0-192cd7202e82
