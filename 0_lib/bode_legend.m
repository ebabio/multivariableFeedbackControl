function bode_legend(figure_handle, varargin)
%%BODE_LEGEND Add legend to a bodeplot figure

axes_handles = findall(figure_handle, 'type', 'axes');
for i=2:length(axes_handles)
legend(axes_handles(i), varargin)
end
